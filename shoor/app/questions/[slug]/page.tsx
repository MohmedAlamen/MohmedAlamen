export default function QuestionDetailsPage({ params }: { params: { slug: string } }) { return <div className="p-6">Question detail: {params.slug}</div>; }
