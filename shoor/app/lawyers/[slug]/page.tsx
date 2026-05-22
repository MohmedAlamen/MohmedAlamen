export default function LawyerProfilePage({ params }: { params: { slug: string } }) { return <div className="p-6">Lawyer profile: {params.slug}</div>; }
